package com.koreab2b.mro.common.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.common.coco.controller.FileUploadForm;
import com.koreab2b.mro.common.mdcm.dao.MasterMdCmStndrdCatalogDetailPopDao;

@Service("masterMdCmStndrdCatalogDetailPopService")
public class MasterMdCmStndrdCatalogDetailPopServiceImpl implements MasterMdCmStndrdCatalogDetailPopService {
	
	@Autowired
	private MasterMdCmStndrdCatalogDetailPopDao masterMdCmStndrdCatalogDetailPopDao;

	// 조회
	public List<Map<String,String>> getList(Map<String,String> formData) {
		return masterMdCmStndrdCatalogDetailPopDao.selectList(formData);
	}	
	
	// 저장
	@Transactional
	public String updateSelectedData (Map<String,String> formData) {
		return masterMdCmStndrdCatalogDetailPopDao.updateSelectedData(formData);
	}
	
	// 이미지상세등록
	public String addMasterMdCmStndCatalogAlterPop(FileUploadForm uploadForm, Map<String,String> _pList) {
		return masterMdCmStndrdCatalogDetailPopDao.addMasterMdCmStndCatalogAlterPop(uploadForm, _pList);
	}	
	
	// 이미지상세등록
	public String addMasterMdCmStndCatalogAlterDetailPop(FileUploadForm uploadForm, Map<String,String> _pList) {
		return masterMdCmStndrdCatalogDetailPopDao.addMasterMdCmStndCatalogAlterDetailPop(uploadForm, _pList);
	}	

}
