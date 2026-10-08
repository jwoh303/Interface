package com.koreab2b.mro.master.clmg.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.clmg.dao.MasterClMgBasicCreditRegDao;

@Service("masterClMgBasicCreditRegService")
public class MasterClMgBasicCreditRegServiceImpl implements MasterClMgBasicCreditRegService {
	@Autowired
	private MasterClMgBasicCreditRegDao masterClMgBasicCreditRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterClMgBasicCreditRegDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String insertSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterClMgBasicCreditRegDao.insertSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String deleteSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterClMgBasicCreditRegDao.deleteSelectedData(formData, gridData);
	}
	// 품의상신
	@Transactional
	public String apprMasterClMgBasicCreditReg(Map<String,String>  formData, List<Object> gridData) {
		return masterClMgBasicCreditRegDao.apprMasterClMgBasicCreditReg(formData, gridData);
	}
	
}
