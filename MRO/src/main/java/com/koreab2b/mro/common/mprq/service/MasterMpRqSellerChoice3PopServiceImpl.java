package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqSellerChoice3PopDao;

@Service("masterMpRqSellerChoice3PopService")
public class MasterMpRqSellerChoice3PopServiceImpl implements MasterMpRqSellerChoice3PopService {
	
	@Autowired
	private MasterMpRqSellerChoice3PopDao masterMpRqSellerChoice3PopDao;

	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqSellerChoice3PopDao.selectList(formData);
	}	
	
	public List<Map<String,String>> getListHd(Map<String,Object> formData) {
		return masterMpRqSellerChoice3PopDao.selectListHd(formData);
	}	
	
	public List<Map<String,String>> getListCode(Map<String,Object> formData) {
		return masterMpRqSellerChoice3PopDao.selectListCode(formData);
	}	
	
	public List<Map<String,String>> getListReNote(Map<String,Object> formData) {
		return masterMpRqSellerChoice3PopDao.selectListReNote(formData);
	}
	
	public String updateFileUpload(Map<String,String> formData) {
		return masterMpRqSellerChoice3PopDao.updateFileUpload(formData);
	}	
	
	public String saveMasterMpRqClose(Map<String,String> formData) {
		return masterMpRqSellerChoice3PopDao.saveMasterMpRqClose(formData);
	}	
	
	public List<Map<String,String>> getBuyerRate(Map<String,Object> formData) {
		return masterMpRqSellerChoice3PopDao.getBuyerRate(formData);
	}	
	public List<Map<String,String>> getBuyerSum(Map<String,Object> formData) {
		return masterMpRqSellerChoice3PopDao.getBuyerSum(formData);
	}
	public List<Map<String,String>> getBuyerSumB(Map<String,Object> formData) {
		return masterMpRqSellerChoice3PopDao.getBuyerSumB(formData);
	}
	public List<Map<String,String>> getProcessImportRate(Map<String,Object> formData) {
		return masterMpRqSellerChoice3PopDao.getProcessImportRate(formData);
	}	
	
	public String saveMasterMpRqAgentSel(Map<String,String>  formData, List<Object> gridData) {
		return masterMpRqSellerChoice3PopDao.saveMasterMpRqAgentSel(formData, gridData);
	}
	public void saveMasterMpRqMarketUnitPriceYn(Map<String,String>  formData) {
		masterMpRqSellerChoice3PopDao.saveMasterMpRqMarketUnitPriceYn(formData);
	}	
	

}
