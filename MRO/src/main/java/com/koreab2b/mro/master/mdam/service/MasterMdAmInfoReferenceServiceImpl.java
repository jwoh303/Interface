package com.koreab2b.mro.master.mdam.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdam.dao.MasterMdAmInfoReferenceDao;

@Service("masterMdAmInfoReferenceService")
public class MasterMdAmInfoReferenceServiceImpl implements MasterMdAmInfoReferenceService {
	
	@Autowired
	private MasterMdAmInfoReferenceDao masterMdAmInfoReferenceDao;

	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdAmInfoReferenceDao.selectList(formData);
	}	
	
	public Map<String,String> getDetailList(Map<String,String> formData) {
		return masterMdAmInfoReferenceDao.getDetailList(formData);
	}
	
	public void updateDetailList(Map<String,String>  formData) {
		masterMdAmInfoReferenceDao.updateDetailList(formData);
	}
	
	public void deleteDetailList(Map<String,String>  formData) {
		masterMdAmInfoReferenceDao.deleteDetailList(formData);
	}
	
	public void insertDetailList(Map<String,String>  formData) {
		masterMdAmInfoReferenceDao.insertDetailList(formData);
	}


}
