package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCmsItemCategorySelPopDao;

@Service("masterMdCmCmsItemCategorySelPopService")
public class MasterMdCmCmsItemCategorySelPopServiceImpl implements MasterMdCmCmsItemCategorySelPopService {

	@Autowired
	private MasterMdCmCmsItemCategorySelPopDao masterMdCmCmsItemCategorySelPopDao;

	// 카테고리 드릴다운/초기 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCmCmsItemCategorySelPopDao.selectList(formData);
	}

	// 카테고리 검색 조회
	public List<Map<String,String>> getSearchList(Map<String,String> formData) {
		return masterMdCmCmsItemCategorySelPopDao.selectSearchList(formData);
	}

	// 상세분류 속성 조회 (STUB)
	public List<Map<String,String>> getAttrList(Map<String,String> formData) {
		return masterMdCmCmsItemCategorySelPopDao.selectAttrList(formData);
	}

	// 상세분류 정보 단건 조회 (경로/명/카테고리(SG))
	public Map<String,String> getCategoryInfo(Map<String,String> formData) {
		return masterMdCmCmsItemCategorySelPopDao.selectCategoryInfo(formData);
	}

}
