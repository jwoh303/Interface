package com.koreab2b.mro.master.mdcm.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreab2b.mro.master.mdcm.dao.MasterMdCmChemicalMatInfoDao;

@Service("masterMdCmChemicalMatInfoService")
public class MasterMdCmChemicalMatInfoServiceImpl implements MasterMdCmChemicalMatInfoService {
	
	@Autowired
	private MasterMdCmChemicalMatInfoDao masterMdCmChemicalMatInfoDao;

	// 리스트 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMdCmChemicalMatInfoDao.selectList(param);
	}	
	//물질정보 상세 팝업 조성정보 헤드 조회	
	public List<Map<String,String>> getMasterMdCmChemicalMatInfoHdList(Map<String,String> formData) {
		return masterMdCmChemicalMatInfoDao.getMasterMdCmChemicalMatInfoHdList(formData);
	}
	// 취소
	@Transactional
	public String cancleMasterMdCmChemicalMatInfo(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmChemicalMatInfoDao.cancleMasterMdCmChemicalMatInfo(formData, gridData);
	}
	// 저장
	@Transactional
	public String saveMasterMdCmChemicalMatInfo(Map<String,String>  formData, List<Object> gridData) {
		return masterMdCmChemicalMatInfoDao.saveMasterMdCmChemicalMatInfo(formData, gridData);
	}
}
