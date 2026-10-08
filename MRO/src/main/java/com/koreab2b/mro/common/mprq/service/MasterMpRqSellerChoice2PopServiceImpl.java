package com.koreab2b.mro.common.mprq.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mprq.dao.MasterMpRqSellerChoice2PopDao;

@Service("masterMpRqSellerChoice2PopService")
public class MasterMpRqSellerChoice2PopServiceImpl implements MasterMpRqSellerChoice2PopService {
	
	@Autowired
	private MasterMpRqSellerChoice2PopDao masterMpRqSellerChoice2PopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,Object> formData) {
		return masterMpRqSellerChoice2PopDao.selectList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getListHd(Map<String,Object> formData) {
		return masterMpRqSellerChoice2PopDao.getListHd(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getListDetail(Map<String,Object> formData) {
		return masterMpRqSellerChoice2PopDao.getListDetail(formData);
	}	
	
	public String saveReAgentSelect(Map<String,String>  formData, List<Object> gridData){
		return masterMpRqSellerChoice2PopDao.saveReAgentSelect(formData, gridData);
	}
	public String saveAllAgentSel(Map<String,String>  formData, List<Object> gridData){
		return masterMpRqSellerChoice2PopDao.saveAllAgentSel(formData, gridData);
	}
}
