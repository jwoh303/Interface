package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoClosingDetailDao;

@Service("masterMpSoClosingDetailService")
public class MasterMpSoClosingDetailServiceImpl implements MasterMpSoClosingDetailService {
	
	@Autowired
	private MasterMpSoClosingDetailDao masterMpSoClosingDetailDao;
  
	
	// 리스트조회
	public List<Map<String,String>> searchMasterMpSoClosingDetailList(Map<String,Object>  param) {
		return masterMpSoClosingDetailDao.searchMasterMpSoClosingDetailList(param);
	}	

	// 입고취소
	public String setNewGrDelChange_Item(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoClosingDetailDao.setNewGrDelChange_Item(formData, gridData);
	}	
	
	// 발주삭제
	public String setNewPODelete_Item(Map<String,String>  formData, List<Object> gridData) {
		return masterMpSoClosingDetailDao.setNewPODelete_Item(formData, gridData);
	}	
}
