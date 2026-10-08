package com.koreab2b.mro.master.mdct.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdct.dao.MasterMdctBuyerIrsnManageDao;

@Service("masterMdctBuyerIrsnManageService")
public class MasterMdctBuyerIrsnManageServiceImpl implements MasterMdctBuyerIrsnManageService {
	
	@Autowired
	private MasterMdctBuyerIrsnManageDao masterMdctBuyerIrsnManageDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdctBuyerIrsnManageDao.selectList(param);
	}
	
	// 담당자 중복 체크
	public String getKepUserIdCheck(Map<String,String>  formData, List<Object> gridData) {
		return masterMdctBuyerIrsnManageDao.selectKepUserIdCheck(formData, gridData);
	}
	
	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdctBuyerIrsnManageDao.updateSelectedData(formData, gridData);
	}
	
	// 저장
	@Transactional
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdctBuyerIrsnManageDao.deleteSelectedData(formData, gridData);
	}
	
	
}
