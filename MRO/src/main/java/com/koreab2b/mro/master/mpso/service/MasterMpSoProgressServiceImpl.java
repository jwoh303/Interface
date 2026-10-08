package com.koreab2b.mro.master.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mpso.dao.MasterMpSoProgressDao;

@Service("masterMpSoProgressService")
public class MasterMpSoProgressServiceImpl implements MasterMpSoProgressService {
	
	@Autowired
	private MasterMpSoProgressDao masterMpSoProgressDao;

	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoProgressDao.selectList(formData);
	}
	
	public int updateSelectedData(Map<String,String> formData, List<Object> gridData) {
		return masterMpSoProgressDao.updateSelectedData(formData, gridData);
	}
	
	public int updateFileData(Map<String,String> formData, List<Object> gridData) {
		return masterMpSoProgressDao.updateFileData(formData, gridData);
	}
	
	public int saveIKENSelectedData(Map<String,String> formData, List<Object> gridData) {
		return masterMpSoProgressDao.saveIKENSelectedData(formData, gridData);
	}
	
	
	public String getMasterMpSoMyColManagePopList(Map<String,Object>  formData) {
		return masterMpSoProgressDao.selectMasterMpSoMyColManagePopList(formData);
	}
	
	public String saveMasterMpSoMyColManagePop(Map<String,String> pMap) {
		return masterMpSoProgressDao.insertMasterMpSoMyColManagePop(pMap);
	}
	
	public List<Map<String,String>> getDownLoadList(Map<String,Object> formData) {
		return masterMpSoProgressDao.selectDownLoadList(formData);
	}
	
}
