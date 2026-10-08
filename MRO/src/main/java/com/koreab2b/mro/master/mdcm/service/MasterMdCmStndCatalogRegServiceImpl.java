package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmStndCatalogRegDao;

@Service("masterMdCmStndCatalogRegService")
public class MasterMdCmStndCatalogRegServiceImpl implements MasterMdCmStndCatalogRegService {
	
	@Autowired
	private MasterMdCmStndCatalogRegDao masterMdCmStndCatalogRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmStndCatalogRegDao.selectList(param);
	}	

	// 생성
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmStndCatalogRegDao.updateSelectedData(formData, gridData);
	}	

	// 등록품의
	@Transactional
	public Map<String,String> saveMasterMdCmStndCatalogApprList(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmStndCatalogRegDao.saveMasterMdCmStndCatalogApprList(formData, gridData);
	}
	
	// 등록품의팝업
	@Transactional
	public Map<String,String> saveMasterMdCmStndCatalogApprPop(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmStndCatalogRegDao.saveMasterMdCmStndCatalogApprPop(formData, gridData);
	}
	
	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmStndCatalogRegDao.deleteSelectedData(formData, gridData);
	}
	
	// 파일업로드
	@Transactional
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmStndCatalogRegDao.batchSelectedData(formData, gridData);
	}
	
	// 임시저장
	@Transactional
	public String saveTempMasterMdCmStndCatalogRegList(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmStndCatalogRegDao.saveTempMasterMdCmStndCatalogRegList(formData, gridData);
	}
	
	// 생성
	@Transactional
	public String saveMasterMdCmStndCatalogRegPop(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmStndCatalogRegDao.saveMasterMdCmStndCatalogRegPop(formData, gridData);
	}
}
