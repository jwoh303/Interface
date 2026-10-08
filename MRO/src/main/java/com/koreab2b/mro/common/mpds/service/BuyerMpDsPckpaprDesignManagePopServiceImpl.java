package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpds.dao.BuyerMpDsPckpaprDesignManagePopDao;

@Service("buyerMpDsPckpaprDesignManagePopService")
public class BuyerMpDsPckpaprDesignManagePopServiceImpl implements BuyerMpDsPckpaprDesignManagePopService {
	
	@Autowired
	private BuyerMpDsPckpaprDesignManagePopDao buyerMpDsPckpaprDesignManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpDsPckpaprDesignManagePopDao.selectList(formData);
	}	

	/*저장*/
	@Transactional
	public String regEsFiReg(Map<String, String> formData){
		return buyerMpDsPckpaprDesignManagePopDao.updateEsFiReg( formData);
	}	
	@Transactional
	public String regMMReg(Map<String, String> formData){
		return buyerMpDsPckpaprDesignManagePopDao.updateMMReg( formData);
	}	
	@Transactional
	public String regDDReg(Map<String, String> formData){
		return buyerMpDsPckpaprDesignManagePopDao.updateDDReg( formData);
	}	
	@Transactional
	public String regEEReg(Map<String, String> formData){
		return buyerMpDsPckpaprDesignManagePopDao.updateEEReg( formData);
	}	
	@Transactional
	public String regEsMkReg(Map<String, String> formData){
		return buyerMpDsPckpaprDesignManagePopDao.updateEsMkReg( formData);
	}	
	@Transactional
	public String regEsPdReg(Map<String, String> formData){
		return buyerMpDsPckpaprDesignManagePopDao.updateEsPdReg( formData);
	}	
	@Transactional
	public String regEsQaReg(Map<String, String> formData){
		return buyerMpDsPckpaprDesignManagePopDao.updateEsQaReg( formData);
	}	
	
}
