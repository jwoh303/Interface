package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogByitDao;

@Service("masterMdCmCatalogByitService")
public class MasterMdCmCatalogByitServiceImpl implements MasterMdCmCatalogByitService {
	
	@Autowired
	private MasterMdCmCatalogByitDao masterMdCmCatalogByitDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmCatalogByitDao.selectList(param);
	}	

	// 견적카탈로그 품목코드 매핑하기
	@Transactional
	public int saveMasterItemNoMapping(Map<String,String> formData, List<Object> gridData) {
		return masterMdCmCatalogByitDao.saveMasterItemNoMapping(formData, gridData);
	}
}
