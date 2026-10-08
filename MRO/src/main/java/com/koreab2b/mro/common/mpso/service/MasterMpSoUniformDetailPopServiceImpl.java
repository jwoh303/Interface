package com.koreab2b.mro.common.mpso.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.koreab2b.mro.common.mpso.dao.MasterMpSoUniformDetailPopDao;

@Service("masterMpSoUniformDetailPopService")
public class MasterMpSoUniformDetailPopServiceImpl implements MasterMpSoUniformDetailPopService {
	
	@Autowired
	private MasterMpSoUniformDetailPopDao masterMpSoUniformDetailPopDao;
	
	// 조회
	public List<Map<String,String>> getHdList(Map<String,String> formData) {
		return masterMpSoUniformDetailPopDao.selectHdList(formData);
	}
	
	// 조회
	public List<Map<String,String>> getList(Map<String,Object> param) {
		return masterMpSoUniformDetailPopDao.selectList(param);
	}	
	
	// 저장
	public String updateSelectedData(Map<String,String>  formData){
		return masterMpSoUniformDetailPopDao.updateSelectedData(formData);
	}
}
