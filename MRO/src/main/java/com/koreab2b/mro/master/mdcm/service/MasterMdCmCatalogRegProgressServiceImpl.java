package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogRegProgressDao;

@Service("masterMdCmCatalogRegProgressService")
public class MasterMdCmCatalogRegProgressServiceImpl implements MasterMdCmCatalogRegProgressService {
	
	@Autowired
	private MasterMdCmCatalogRegProgressDao masterMdCmCatalogRegProgressDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCatalogRegProgressDao.selectList(param);
	}

	// 재소싱요청
	@Transactional
	public String updateReSourcingData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegProgressDao.updateReSourcingData(formData, gridData);
	}

	// 취소
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegProgressDao.deleteSelectedData(formData, gridData);
	}
	
	// 소싱변경 업로드
	@Transactional
	public String batchSourcingData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegProgressDao.batchSourcingData(formData, gridData);
	}
	
	// 판가변경 업로드
	@Transactional
	public String batchUnitPriceData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegProgressDao.batchUnitPriceData(formData, gridData);
	}
	
	// 카탈로그 등록 차수 팝업 조회
	public List<Map<String,String>> getMasterMdCmCatalogRegRevisionList(Map<String,Object> param) {
		return masterMdCmCatalogRegProgressDao.getMasterMdCmCatalogRegRevisionList(param);
	}
	
	// 소싱제출, 판가제출 품의 상신
	@Transactional
	public Map<String,String> updateData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCatalogRegProgressDao.updateData(formData, gridData);
	}
}
