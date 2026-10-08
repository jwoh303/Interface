package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoGrDetailDao;

@Service("masterMpSoGrDetailService")
public class MasterMpSoGrDetailServiceImpl implements MasterMpSoGrDetailService {
	
	@Autowired
	private MasterMpSoGrDetailDao masterMpSoGrDetailDao;
	
	// 리스트조회
	public List<Map<String,String>> searchMasterMpSoGrDetailList(Map<String,Object>  param) {
		return masterMpSoGrDetailDao.searchMasterMpSoGrDetailList(param);
	}
	public List<Map<String,String>> searchMasterMpSoGrDetailList_v2(Map<String,Object>  param) {
		return masterMpSoGrDetailDao.searchMasterMpSoGrDetailList_v2(param);
	}	

	// 입고취소
	public String setNewGrDelChange_Item(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoGrDetailDao.setNewGrDelChange_Item(formData, gridData);
	}
	public String setNewGrDelChange_Item_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoGrDetailDao.setNewGrDelChange_Item_v2(formData, gridData);
	}

	// 저장
	public String saveMasterMpSoGrDetailList(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoGrDetailDao.saveMasterMpSoGrDetailList(formData, gridData);
	}
	public String saveMasterMpSoGrDetailList_v2(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoGrDetailDao.saveMasterMpSoGrDetailList_v2(formData, gridData);
	}
}
