package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.mdcm.dao.MasterMdCmStndrdCatalogDetailViewPopDao;

@Service("masterMdCmStndrdCatalogDetailViewPopService")
public class MasterMdCmStndrdCatalogDetailViewPopServiceImpl implements MasterMdCmStndrdCatalogDetailViewPopService {
	
	@Autowired
	private MasterMdCmStndrdCatalogDetailViewPopDao masterMdCmStndrdCatalogDetailViewPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCmStndrdCatalogDetailViewPopDao.selectList(formData);
	}	
	
	// 상품상세속성
	public List<Map<String,String>> getCmsCatalogDispPopAttr(Map<String,String>  formData){
		return masterMdCmStndrdCatalogDetailViewPopDao.getCmsCatalogDispPopAttr(formData);
	}
	
	// 이미지
	public List<Map<String,String>> getCmsCatalogDispPopImg(Map<String,String>  formData){
		return masterMdCmStndrdCatalogDetailViewPopDao.getCmsCatalogDispPopImg(formData);
	}
	
	// 저장
	@Transactional
	public String updateSelectedData (Map<String,String> formData) {
		return masterMdCmStndrdCatalogDetailViewPopDao.updateSelectedData(formData);
	}
	

}
