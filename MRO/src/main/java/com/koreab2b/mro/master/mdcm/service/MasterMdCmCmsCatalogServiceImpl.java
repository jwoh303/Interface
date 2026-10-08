package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCmsCatalogDao;

@Service("masterMdCmCmsCatalogService")
public class MasterMdCmCmsCatalogServiceImpl implements MasterMdCmCmsCatalogService {
	
	@Autowired
	private MasterMdCmCmsCatalogDao masterMdCmCmsCatalogDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCmsCatalogDao.selectList(param);
	}	

	// 엑셀 리스트 조회
	public List<Map<String,String>> getExcelList(Map<String,Object> param) {
		return masterMdCmCmsCatalogDao.selecExceltList(param);
	}
	
	//카테고리 속성건수 조회
	public String getCategoriAttributeListCount(Map<String, String> formData) {
		return masterMdCmCmsCatalogDao.getCategoriAttributeListCount(formData);
	}

	//카테고리 속성 조회
	public List<Map<String, String>> getCategoriAttributeList(Map<String, String> formData) {
		return masterMdCmCmsCatalogDao.getCategoriAttributeList(formData);
	}
}
