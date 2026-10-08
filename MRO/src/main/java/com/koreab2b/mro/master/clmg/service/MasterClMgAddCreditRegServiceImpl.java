package com.koreab2b.mro.master.clmg.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.clmg.dao.MasterClMgAddCreditRegDao;

@Service("masterClMgAddCreditRegService")
public class MasterClMgAddCreditRegServiceImpl implements MasterClMgAddCreditRegService {
	@Autowired
	private MasterClMgAddCreditRegDao masterClMgAddCreditRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterClMgAddCreditRegDao.selectList(param);
	}	
	// 리스트 조회
	public List<Map<String,String>> getMasterClmgLoanHistoryPop(Map<String,Object> param) {
		return masterClMgAddCreditRegDao.selectMasterClmgLoanHistoryPop(param);
	}
	// 저장
	@Transactional
	public String insertSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterClMgAddCreditRegDao.insertSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterClMgAddCreditRegDao.deleteSelectedData(formData, gridData);
	}
}
