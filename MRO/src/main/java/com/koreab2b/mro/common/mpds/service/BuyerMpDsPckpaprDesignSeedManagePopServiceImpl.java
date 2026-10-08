package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpds.dao.BuyerMpDsPckpaprDesignSeedManagePopDao;

@Service("buyerMpDsPckpaprDesignSeedManagePopService")
public class BuyerMpDsPckpaprDesignSeedManagePopServiceImpl implements BuyerMpDsPckpaprDesignSeedManagePopService {
	
	@Autowired
	private BuyerMpDsPckpaprDesignSeedManagePopDao buyerMpDsPckpaprDesignSeedManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return buyerMpDsPckpaprDesignSeedManagePopDao.selectList(formData);
	}	
	
	// 저장
	public String saveSelectedData_1(Map<String,String> formData) {
		return buyerMpDsPckpaprDesignSeedManagePopDao.updateSelectedData_1(formData);
	}	
	public String saveSelectedData_2(Map<String,String> formData) {
		return buyerMpDsPckpaprDesignSeedManagePopDao.updateSelectedData_2(formData);
	}	
	public String saveSelectedData_3(Map<String,String> formData) {
		return buyerMpDsPckpaprDesignSeedManagePopDao.updateSelectedData_3(formData);
	}	
	public String saveSelectedData_4(Map<String,String> formData) {
		return buyerMpDsPckpaprDesignSeedManagePopDao.updateSelectedData_4(formData);
	}	
	public String saveSelectedData_5(Map<String,String> formData) {
		return buyerMpDsPckpaprDesignSeedManagePopDao.updateSelectedData_5(formData);
	}	
	public String saveSelectedData_6(Map<String,String> formData) {
		return buyerMpDsPckpaprDesignSeedManagePopDao.updateSelectedData_6(formData);
	}	
	public String saveSelectedData_7(Map<String,String> formData) {
		return buyerMpDsPckpaprDesignSeedManagePopDao.updateSelectedData_7(formData);
	}	
	public String saveSelectedData_8(Map<String,String> formData) {
		return buyerMpDsPckpaprDesignSeedManagePopDao.updateSelectedData_8(formData);
	}	
	public String saveSelectedData_9(Map<String,String> formData) {
		return buyerMpDsPckpaprDesignSeedManagePopDao.updateSelectedData_9(formData);
	}	

}
