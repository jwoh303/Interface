package com.koreab2b.mro.common.mpds.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mpds.dao.MasterMpDsPckpaprDesignCropProtectManagePopDao;

@Service("masterMpDsPckpaprDesignCropProtectManagePopService")
public class MasterMpDsPckpaprDesignCropProtectManagePopServiceImpl implements MasterMpDsPckpaprDesignCropProtectManagePopService {
	
	@Autowired
	private MasterMpDsPckpaprDesignCropProtectManagePopDao masterMpDsPckpaprDesignCropProtectManagePopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMpDsPckpaprDesignCropProtectManagePopDao.selectList(formData);
	}	

	// 바코드부여
	public String getBarCode(Map<String,String> formData) {
		return masterMpDsPckpaprDesignCropProtectManagePopDao.selectBarCode(formData);
	}
	
	@Transactional
	public String regSave(Map<String, String> formData){
		return masterMpDsPckpaprDesignCropProtectManagePopDao.updateReg( formData);
	}	
	@Transactional
	public String regSaveMM(Map<String, String> formData){
		return masterMpDsPckpaprDesignCropProtectManagePopDao.updateRegMM( formData);
	}	
	@Transactional
	public String regSave01(Map<String, String> formData){
		return masterMpDsPckpaprDesignCropProtectManagePopDao.updateReg01( formData);
	}		
}
