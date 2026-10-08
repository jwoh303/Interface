package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoOrderInfoAlterAfterPopDao;

@Service("masterMpSoOrderInfoAlterAfterPopService")
public class MasterMpSoOrderInfoAlterAfterPopServiceImpl implements MasterMpSoOrderInfoAlterAfterPopService {
	
	@Autowired
	private MasterMpSoOrderInfoAlterAfterPopDao masterMpSoOrderInfoAlterAfterPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpSoOrderInfoAlterAfterPopDao.selectList(formData);
	}	
	
	
	public List<Map<String,String>> getSysopOrderChangePoAfterHDPop(Map<String,String>  formData) {
		return masterMpSoOrderInfoAlterAfterPopDao.getSysopOrderChangePoAfterHDPop(formData);
	}		
	public List<Map<String,String>> getSysopOrderChangePoAfterDTPop(Map<String,Object>  formData) {
		return masterMpSoOrderInfoAlterAfterPopDao.getSysopOrderChangePoAfterDTPop(formData);
	}		
	
	
	public String setSysopOrderChangeAfterSave(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterAfterPopDao.setSysopOrderChangeAfterSave(formData,gridData);
	}		
	public String setSysopOrderChangeAfterProcessTypeModify(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterAfterPopDao.setSysopOrderChangeAfterProcessTypeModify(formData,gridData);
	}		
	public String setSysopOrderChangeAfterAgentModify(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterAfterPopDao.setSysopOrderChangeAfterAgentModify(formData,gridData);
	}		
	public String setSysopOrderChangeAfterDelete(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterAfterPopDao.setSysopOrderChangeAfterDelete(formData,gridData);
	}		
	public String setSysopOrderChangeAfterPrice(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterAfterPopDao.setSysopOrderChangeAfterPrice(formData,gridData);
	}		
	public String setSysopOrderChangeAfterRdDate(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterAfterPopDao.setSysopOrderChangeAfterRdDate(formData,gridData);
	}		
	public String setSysopOrderChangeAfterPoInit(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterAfterPopDao.setSysopOrderChangeAfterPoInit(formData,gridData);
	}		
	public String setSysopOrderChangeAfterPrice2(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterAfterPopDao.setSysopOrderChangeAfterPrice2(formData,gridData);
	}		
	public String setCheckInterBizPoStatus(Map<String,String>  formData, List<Object> gridData){
		return masterMpSoOrderInfoAlterAfterPopDao.setCheckInterBizPoStatus(formData,gridData);
	}		 
	

}
