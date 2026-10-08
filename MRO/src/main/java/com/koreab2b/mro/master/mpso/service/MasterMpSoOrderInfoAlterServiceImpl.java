package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoOrderInfoAlterDao;

@Service("masterMpSoOrderInfoAlterService")
public class MasterMpSoOrderInfoAlterServiceImpl implements MasterMpSoOrderInfoAlterService {
	
	@Autowired
	private MasterMpSoOrderInfoAlterDao masterMpSoOrderInfoAlterDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpSoOrderInfoAlterDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderInfoAlterDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderInfoAlterDao.deleteSelectedData(formData, gridData);
	}
	
	
	
	
	
	
	
	
	
	
	// 리스트조회 ( 일괄)
	public List<Map<String,String>> getMasterMpSoOrderInfoAlterMultiList(Map<String,Object>  param) {
		return masterMpSoOrderInfoAlterDao.getMasterMpSoOrderInfoAlterMultiList(param);
	}
	public List<Map<String,String>> getMasterMpSoOrderInfoAlterMultiList_v2(Map<String,Object>  param) {
		return masterMpSoOrderInfoAlterDao.getMasterMpSoOrderInfoAlterMultiList_v2(param);
	}
	

	// 저장  ( 일괄)
	public String saveMasterMpSoOrderInfoAlterMultiList(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderInfoAlterDao.saveMasterMpSoOrderInfoAlterMultiList(formData, gridData);
	}
	
	
	// 삭제 ( 일괄)
	public String delMasterMpSoOrderInfoAlterMultList(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoOrderInfoAlterDao.delMasterMpSoOrderInfoAlterMultList(formData, gridData);
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
