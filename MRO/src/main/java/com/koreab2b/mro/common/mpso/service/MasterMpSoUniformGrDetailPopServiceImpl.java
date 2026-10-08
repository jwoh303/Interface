package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoUniformGrDetailPopDao;

@Service("masterMpSoUniformGrDetailPopService")
public class MasterMpSoUniformGrDetailPopServiceImpl implements MasterMpSoUniformGrDetailPopService {
	
	@Autowired
	private MasterMpSoUniformGrDetailPopDao masterMpSoUniformGrDetailPopDao;

	// 조회
	public List<Map<String,String>> getHdList(Map<String,String> formData) {
		return masterMpSoUniformGrDetailPopDao.selectHdList(formData);
	}	
	
	// 조회
	public List<Map<String,String>> getDtList(Map<String,String> formData) {
		return masterMpSoUniformGrDetailPopDao.selectDtList(formData);
	}
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData){
		return masterMpSoUniformGrDetailPopDao.updateSelectedData(formData);
	}
}
