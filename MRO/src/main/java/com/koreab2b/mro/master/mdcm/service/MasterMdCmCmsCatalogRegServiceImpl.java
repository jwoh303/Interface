package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCmsCatalogRegDao;

@Service("masterMdCmCmsCatalogRegService")
public class MasterMdCmCmsCatalogRegServiceImpl implements MasterMdCmCmsCatalogRegService {
	
	@Autowired
	private MasterMdCmCmsCatalogRegDao masterMdCmCmsCatalogRegDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCmsCatalogRegDao.selectList(param);
	}	

	// 생성
	@Transactional
	public String updateSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCmsCatalogRegDao.updateSelectedData(formData, gridData);
	}	

	// 삭제
	@Transactional
	public String delSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCmsCatalogRegDao.deleteSelectedData(formData, gridData);
	}
	
	// 파일업로드
	@Transactional
	public String batchSelectedData(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmCmsCatalogRegDao.batchSelectedData(formData, gridData);
	}
}
