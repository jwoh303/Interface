package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoOrderIvGrCreationDao;

@Service("masterMpSoOrderIvGrCreationService")
public class MasterMpSoOrderIvGrCreationServiceImpl implements MasterMpSoOrderIvGrCreationService {
	
	@Autowired
	private MasterMpSoOrderIvGrCreationDao masterMpSoOrderIvGrCreationDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpSoOrderIvGrCreationDao.selectList(param);
	}	

	
	
	// 엑셀 업로딩검증 결과 조회
	public List<Map<String,String>> searchMasterMpSoBuyerOrderCreationListExcelResult(Map<String,Object>  param) {
		return masterMpSoOrderIvGrCreationDao.searchMasterMpSoBuyerOrderCreationListExcelResult(param);
	}	

	// 엑셀 업로딩검증 결과를 저장
	public String updateMasterMpSoBuyerOrderCreationListExcelCheckResult(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderIvGrCreationDao.updateMasterMpSoBuyerOrderCreationListExcelCheckResult(formData, gridData);
	}	
	 
	
	// 엑셀 업로딩검증
	@Transactional
	public String updateSelectedDataExcelCheck(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderIvGrCreationDao.updateSelectedDataExcelCheck(formData, gridData);
	}	

	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderIvGrCreationDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderIvGrCreationDao.deleteSelectedData(formData, gridData);
	}
	
	
	// PM번호 생성 - 결재 전처리
	@Transactional
	public String getPmNoMasterMpSoBuyerOrderCreationList(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderIvGrCreationDao.getPmNoMasterMpSoBuyerOrderCreationList(formData, gridData);
	}
	


	// 결재 후처리
	@Transactional
	public String savePmNoAfterMasterMpSoBuyerOrderCreationList(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderIvGrCreationDao.savePmNoAfterMasterMpSoBuyerOrderCreationList(formData, gridData);
	}
	
	// 값저장
	@Transactional
	public String savingSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderIvGrCreationDao.savingSelectedData(formData, gridData);
	}
	
}
