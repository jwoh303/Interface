package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsDongbuPckpaprDesignSeedManagePopDao;

@Service("masterMpDsDongbuPckpaprDesignSeedManagePopService")
public class MasterMpDsDongbuPckpaprDesignSeedManagePopServiceImpl implements MasterMpDsDongbuPckpaprDesignSeedManagePopService {
	
	@Autowired
	private MasterMpDsDongbuPckpaprDesignSeedManagePopDao masterMpDsDongbuPckpaprDesignSeedManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMpDsDongbuPckpaprDesignSeedManagePopDao.selectList(formData);
	}	

	@Transactional
	public String regSave(Map<String, String> formData){
		return masterMpDsDongbuPckpaprDesignSeedManagePopDao.updateReg( formData);
	}	
	@Transactional
	public String regSaveMM(Map<String, String> formData){
		return masterMpDsDongbuPckpaprDesignSeedManagePopDao.updateRegMM( formData);
	}	
	@Transactional
	public String regSave01(Map<String, String> formData){
		return masterMpDsDongbuPckpaprDesignSeedManagePopDao.updateReg01( formData);
	}			

}
