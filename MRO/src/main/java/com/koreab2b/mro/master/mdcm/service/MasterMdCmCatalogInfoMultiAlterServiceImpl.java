package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogAlterDao;
import com.koreab2b.mro.master.mdcm.dao.MasterMdCmCatalogInfoMultiAlterDao;

@Service("masterMdCmCatalogInfoMultiAlterService")
public class MasterMdCmCatalogInfoMultiAlterServiceImpl implements MasterMdCmCatalogInfoMultiAlterService {
	
	@Autowired
	private MasterMdCmCatalogInfoMultiAlterDao masterMdCmCatalogInfoMultiAlterDao;
	// 카탈로그 일괄수정 조회
	public List<Map<String,String>> getMasterMdCmCatalogInfoMultiAlter(Map<String,Object>  param){
		return masterMdCmCatalogInfoMultiAlterDao.getMasterMdCmCatalogInfoMultiAlter(param);
	}
	// 카탈로그 일괄수정 엑셀 업로드
	public String batchMasterMdCmCatalogInfoMultiAlter(Map<String, String> param,List<Object> gridData){
		return masterMdCmCatalogInfoMultiAlterDao.batchMasterMdCmCatalogInfoMultiAlter(param , gridData);
	}
	// 카탈로그 일괄수정 삭제
	public String delMasterMdCmCatalogInfoMultiAlter(Map<String, String> param,List<Object> gridData)  {
		return masterMdCmCatalogInfoMultiAlterDao.delMasterMdCmCatalogInfoMultiAlter(param , gridData);
	}
	// 카탈로그 일괄수정 반영대상 검증
	public List<Map<String,String>> getMasterMdCmCatalogInfoBeforeAfter(Map<String,Object>  param){
		return masterMdCmCatalogInfoMultiAlterDao.getMasterMdCmCatalogInfoBeforeAfter(param);
	}
	// 카탈로그 일괄수정 품의 상신
	public String requestMasterMdCmCatalogInfoSearchPop(Map<String, String> param,List<Object> gridData){
		return masterMdCmCatalogInfoMultiAlterDao.requestMasterMdCmCatalogInfoSearchPop(param , gridData);
	}

}
