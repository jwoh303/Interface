package com.koreab2b.mro.common.wmre.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.wmre.dao.MasterWmReReturnEntryPopDao;

@Service("masterWmReReturnEntryPopService")
public class MasterWmReReturnEntryPopServiceImpl implements MasterWmReReturnEntryPopService {
	
	@Autowired
	private MasterWmReReturnEntryPopDao masterWmReReturnEntryPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterWmReReturnEntryPopDao.selectList(formData);
	}	

	public List<Map<String,String>> getPop(Map<String,String> formData) {
		return masterWmReReturnEntryPopDao.selectPopList(formData);
	}	
	
	public List<Map<String,String>> getUpdate(Map<String,Object> formData) {
		return masterWmReReturnEntryPopDao.selectUpdateList(formData);
	}	
	public List<Map<String,String>> getMasterWmReReturnEntryPopForUpdateSeller_v2(Map<String,Object> formData) {
		return masterWmReReturnEntryPopDao.getMasterWmReReturnEntryPopForUpdateSeller_v2(formData);
	}
	
	public List<Map<String,String>> getPopBuyer(Map<String,String> formData) {
		return masterWmReReturnEntryPopDao.selectPopBuyerList(formData);
	}
	public List<Map<String,String>> getPopBuyer_v2(Map<String,String> formData) {
		return masterWmReReturnEntryPopDao.getPopBuyer_v2(formData);
	}
	
	public List<Map<String,String>> getRegPop(Map<String,String> formData) {
		return masterWmReReturnEntryPopDao.selectRegPopList(formData);
	}	
	
	public String saveMasterWmReReturnEntryPop(Map<String,String> formData){
		return masterWmReReturnEntryPopDao.saveMasterWmReReturnEntryPop(formData);
	}
	
	public String saveMasterWmReReturnEntryCancelPop(Map<String,String> formData){
		return masterWmReReturnEntryPopDao.saveMasterWmReReturnEntryCancelPop(formData);
	}
	
	public String saveMasterWmReReturnWmNoPop(Map<String,String> formData){
		return masterWmReReturnEntryPopDao.saveMasterWmReReturnWmNoPop(formData);
	}
	public String saveMasterWmReReturnWmNoPop_v2(Map<String,String> formData){
		return masterWmReReturnEntryPopDao.saveMasterWmReReturnWmNoPop_v2(formData);
	}
	
	
	public String cancelMasterWmReReturnWmNoPop(Map<String,String> formData){
		return masterWmReReturnEntryPopDao.cancelMasterWmReReturnWmNoPop(formData);
	}
	
	public List<Map<String,String>> getReReturnPoInfo(Map<String,Object> formData) {
		return masterWmReReturnEntryPopDao.selectReturnPoInfo(formData);
	}
}
