package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClClArApMappingDao;

@Service("masterCmClClArApMappingService")
public class MasterCmClClArApMappingServiceImpl implements MasterCmClClArApMappingService {
	
	@Autowired
	private MasterCmClClArApMappingDao masterCmClClArApMappingDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClClArApMappingDao.selectList(param);
	}	
	// 계산서 리스트 조회
	public List<Map<String,String>> getTaxList(Map<String,Object> param) {
		return masterCmClClArApMappingDao.selectTaxList(param);
	}
	// 계산서 상계처리 매핑
	@Transactional
	public String callProcTaxSkip(Map<String,String>  formData) {
		return masterCmClClArApMappingDao.callProcTaxSkip(formData);
	}
	// 계산서 수동 상계처리
	@Transactional
	public String updateProcTaxSkip(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClClArApMappingDao.updateProcTaxSkip(formData, gridData);
	}
	// 매출 자동매핑
	@Transactional
	public String callProcTaxMappingAr(Map<String,String>  formData) {
		return masterCmClClArApMappingDao.callProcTaxMappingAr(formData);
	}
	// 매입 자동매핑
	@Transactional
	public String callProcTaxMappingAp(Map<String,String>  formData) {
		return masterCmClClArApMappingDao.callProcTaxMappingAp(formData);
	}
	// 저장
	@Transactional
	public String savetMasterCmClArApMappingList(Map<String,String>  formData) {
		return masterCmClClArApMappingDao.savetMasterCmClArApMappingList(formData);
	}
	// 예외저장
	public String saveExceptionMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData){
		return masterCmClClArApMappingDao.saveExceptionMasterCmClArApMappingList(formData, gridData);
	}
	// 확정
	@Transactional
	public String confirmtMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClClArApMappingDao.confirmtMasterCmClArApMappingList(formData, gridData);
	}
	// 매핑취소
	@Transactional
	public String cancleMappingMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClClArApMappingDao.cancleMappingMasterCmClArApMappingList(formData, gridData);
	}
	// 취소
	@Transactional
	public String cancleMasterCmClArApMappingList(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClClArApMappingDao.cancleMasterCmClArApMappingList(formData, gridData);
	}
}
