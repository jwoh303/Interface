package com.koreab2b.mro.master.cmcl.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.cmcl.dao.MasterCmClSalesTaxsheetUploadingCreationDao;

@Service("masterCmClSalesTaxsheetUploadingCreationService")
public class MasterCmClSalesTaxsheetUploadingCreationServiceImpl implements MasterCmClSalesTaxsheetUploadingCreationService {
	
	@Autowired
	private MasterCmClSalesTaxsheetUploadingCreationDao masterCmClSalesTaxsheetUploadingCreationDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterCmClSalesTaxsheetUploadingCreationDao.selectList(param);
	}	

	// 저장
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesTaxsheetUploadingCreationDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterCmClSalesTaxsheetUploadingCreationDao.deleteSelectedData(formData, gridData);
	}
}
