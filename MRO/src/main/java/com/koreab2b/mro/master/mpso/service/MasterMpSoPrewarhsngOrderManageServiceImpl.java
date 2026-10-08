package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoPrewarhsngOrderManageDao;

@Service("masterMpSoPrewarhsngOrderManageService")
public class MasterMpSoPrewarhsngOrderManageServiceImpl implements MasterMpSoPrewarhsngOrderManageService {
	
	@Autowired
	private MasterMpSoPrewarhsngOrderManageDao masterMpSoPrewarhsngOrderManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpSoPrewarhsngOrderManageDao.selectList(param);
	}	

	// 선입고 요청 등록
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoPrewarhsngOrderManageDao.updateSelectedData(formData, gridData);
	}	
	
	// 선입고 요청 취소
	@Transactional
	public String updatePrewarhsngReqCancel(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoPrewarhsngOrderManageDao.updatePrewarhsngReqCancel(formData, gridData);
	}
	
	// 선입고 관리 맵핑 등록 (발주완료)
	@Transactional
	public String updatePrewarhsngMappingReg(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoPrewarhsngOrderManageDao.updatePrewarhsngMappingReg(formData, gridData);
	}
	
	// 선입고 관리 맵핑 등록 (부분발주완료)
	@Transactional
	public String updatePrewarhsngMappingPartialReg(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoPrewarhsngOrderManageDao.updatePrewarhsngMappingPartialReg(formData, gridData);
	}
	
	// 선입고 관리 맵핑 취소(발주취소)
	@Transactional
	public String updatePrewarhsngMappingCancelReg(Map<String,String>  formData) {
		return masterMpSoPrewarhsngOrderManageDao.updatePrewarhsngMappingCancelReg(formData);
	}
	
	// 선입고 관리 다건 맵핑 취소(다건발주취소)
	@Transactional
	public String updatePrewarhsngMappingGrpCancelReg(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoPrewarhsngOrderManageDao.updatePrewarhsngMappingGrpCancelReg(formData, gridData);
	}
	
	// 선입고 관리 거래명세서 생성
	@Transactional
	public String updatesaveMasterMpSoPrewarhsngTranStatementReg(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoPrewarhsngOrderManageDao.updatesaveMasterMpSoPrewarhsngTranStatementReg(formData, gridData);
	}
	
	// 선입고 관리 납품실적
	@Transactional
	public String updatesaveMasterMpSoPrewarhsngDeliveryEndReg(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoPrewarhsngOrderManageDao.updatesaveMasterMpSoPrewarhsngDeliveryEndReg(formData, gridData);
	}

}
