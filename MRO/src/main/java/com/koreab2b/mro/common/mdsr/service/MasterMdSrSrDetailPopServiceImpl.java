package com.koreab2b.mro.common.mdsr.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mdsr.dao.MasterMdSrSrDetailPopDao;

@Service("masterMdSrSrDetailPopServiceImpl")
public class MasterMdSrSrDetailPopServiceImpl  implements MasterMdSrSrDetailPopService {
	@Autowired
	private MasterMdSrSrDetailPopDao masterMdSrSrDetailPopDao;
	
	// 조회
	public List<Map<String,String>> getMasterMdSrSrDetailPop(Map<String,Object> formData) {
		return masterMdSrSrDetailPopDao.getMasterMdSrSrDetailPop(formData);
	}
	
	// 저장
	public String saveMasterMdSrSrDetailPop(Map<String,String>  formData) {
		return masterMdSrSrDetailPopDao.saveMasterMdSrSrDetailPop(formData);
	}
	// 엑셀 pogr조회
	public List<Map<String,String>> getExcelMasterPoGrList(Map<String,Object> formData) {
		return masterMdSrSrDetailPopDao.getExcelMasterPoGrList(formData);
	}
	// 엑셀 pogr조회
	public List<Map<String,String>> getExcelMasterReList(Map<String,Object> formData) {
		return masterMdSrSrDetailPopDao.getExcelMasterReList(formData);
	}
}
