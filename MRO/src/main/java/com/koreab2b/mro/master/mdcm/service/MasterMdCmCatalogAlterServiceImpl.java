package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogAlterDao;

@Service("masterMdCmCatalogAlterService")
public class MasterMdCmCatalogAlterServiceImpl implements MasterMdCmCatalogAlterService {
	
	@Autowired
	private MasterMdCmCatalogAlterDao masterMdCmCatalogAlterDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCatalogAlterDao.selectList(param);
	}	
	// MSDS리스트 조회
	public List<Map<String,String>> geMsdstList(Map<String,Object> param) {
		return masterMdCmCatalogAlterDao.selectMsdsList(param);
	}
	// MSDS상세리스트 조회
	public List<Map<String,String>> geMsdsDetailList(Map<String,Object> param) {
		return masterMdCmCatalogAlterDao.selectMsdsDetailList(param);
	}
	// MSDS상세헤드리스트 조회
	public List<Map<String,String>> geMsdsHeadDetailList(Map<String,Object> param) {
		return masterMdCmCatalogAlterDao.selectMsdsHeadDetailList(param);
	}
	public List<Map<String,String>> geMsdsHeadDetailList_v2(Map<String,Object> param) {
		return masterMdCmCatalogAlterDao.selectMsdsHeadDetailList_v2(param);
	}
	public List<Map<String,String>> getMasterMsdsDetailList_v2(Map<String,Object> param) {
		return masterMdCmCatalogAlterDao.getMasterMsdsDetailList_v2(param);
	}
	
	// MSDS상세리스트 조회
	public List<Map<String,String>> geMsdsRegList(Map<String,Object> param) {
		return masterMdCmCatalogAlterDao.selectMsdsRegList(param);
	}	
	// MSDS상세수정
	public String updateMasterMsdsDetailList(Map<String,String>  formData){
		return masterMdCmCatalogAlterDao.updateMasterMsdsDetailList(formData);
	}
	// MSDS상세등록
	public String insertMasterMsdsDetailList(Map<String,String>  formData){
		return masterMdCmCatalogAlterDao.insertMasterMsdsDetailList(formData);
	}
	// MSDS상세삭제
	public String delMasterMsdsDetailList(Map<String,String>  formData){
		return masterMdCmCatalogAlterDao.delMasterMsdsDetailList(formData);
	}
	// MSDS매핑하기
	@Transactional
	public int saveMasterMsdsMapping(Map<String,String> formData, List<Object> gridData) {
		return masterMdCmCatalogAlterDao.saveMasterMsdsMapping(formData, gridData);
	}
	// MSDS BYIT매핑하기
	@Transactional
	public int saveMasterMsdsByitMapping(Map<String,String> formData, List<Object> gridData) {
		return masterMdCmCatalogAlterDao.saveMasterMsdsByitMapping(formData, gridData);
	}
	public String getBycaComorgSelect(Map<String,Object> param) {
		return masterMdCmCatalogAlterDao.getBycaComorgSelect(param);
	}
	
	// 엑셀 리스트 조회
	public List<Map<String,String>> getExcelList(Map<String,Object> param) {
		return masterMdCmCatalogAlterDao.selecExceltList(param);
	}
	
	public List<Map<String,String>> getMasterMdCmCatalogMultiAlter(Map<String,Object>  param)  {
		return masterMdCmCatalogAlterDao.getMasterMdCmCatalogMultiAlter(param);
	}
	
	public List<Map<String,String>> getWarehouseCodeList(Map<String,Object>  param){
		return masterMdCmCatalogAlterDao.getWarehouseCodeList(param);
	}
	
	public List<Map<String,String>> getMasterMdCmCatalogSearchPop(Map<String,String>  param)  {
		return masterMdCmCatalogAlterDao.getMasterMdCmCatalogSearchPop(param);
	}
	
	
	public String batchMasterMdCmCatalogMultiAlter(Map<String, String> param,List<Object> gridData)  {
		return masterMdCmCatalogAlterDao.batchMasterMdCmCatalogMultiAlter(param , gridData);
	}
	
	public String popBatchMasterMdCmCatalogMultiAlter(Map<String, String> param)  {
		return masterMdCmCatalogAlterDao.popBatchMasterMdCmCatalogMultiAlter(param );
	}
	
	public String delMasterMdCmCatalogMultiAlter(Map<String, String> param,List<Object> gridData)  {
		return masterMdCmCatalogAlterDao.delMasterMdCmCatalogMultiAlter(param , gridData);
	}
	

	
	public String  requestMasterMdCmCatalogSearchPop(Map<String, String> param,List<Object> gridData)  {
		return masterMdCmCatalogAlterDao.requestMasterMdCmCatalogSearchPop(param , gridData);
	}
	
	public String  approvalMasterMdCmCatalogSearchPop(Map<String, String> param)  {
		return masterMdCmCatalogAlterDao.approvalMasterMdCmCatalogSearchPop(param);
	}
	// 결재정보 리스트 조회
	public List<Map<String,String>> getApprInfoList(Map<String,Object> param) {
		return masterMdCmCatalogAlterDao.selectApprInfoList(param);
	}
	// 카탈로그상태 변경
	@Transactional
	public Map<String,String> saveSelectedStatusData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogAlterDao.saveSelectedStatusData(formData, gridData);
	}
	
	// 표준카테고리 엑셀다운로드
	public List<Map<String, String>> getCmsExcelList(Map<String, Object> param) {		
		return masterMdCmCatalogAlterDao.selecCmsExcelList(param);
	}
	
	// MSDS 매핑 해제
	public String  saveSelectedMsdsClean(Map<String, String> param,List<Object> gridData)  {
		return masterMdCmCatalogAlterDao.saveSelectedMsdsClean(param , gridData);
	}
}